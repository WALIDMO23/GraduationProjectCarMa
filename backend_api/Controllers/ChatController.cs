using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using CarMaintenance.Data;
using CarMaintenance.Models;
using CarMaintenance.Hubs;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace CarMaintenance.Controllers
{
    [ApiController]
    [Route("api/chat")]
    public class ChatController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IHubContext<NotificationHub> _hubContext;

        public ChatController(AppDbContext context, IHubContext<NotificationHub> hubContext)
        {
            _context = context;
            _hubContext = hubContext;
        }

        // Fetch messages for a specific ServiceRequestId (Order Id)
        [HttpGet("{serviceRequestId}")]
        public async Task<IActionResult> GetMessages(int serviceRequestId)
        {
            var order = await _context.Orders.FindAsync(serviceRequestId);
            if (order == null)
            {
                return NotFound(new { message = "Order not found" });
            }

            // Chat is only available after acceptance
            if (order.OrderStatus == OrderStatus.Pending)
            {
                return BadRequest(new { message = "Chat is not available before the order is accepted." });
            }

            var messages = await _context.ChatMessages
                .Where(m => m.ServiceRequestId == serviceRequestId)
                .OrderBy(m => m.Timestamp)
                .ToListAsync();

            return Ok(new { success = true, data = messages });
        }

        // Send a message
        [HttpPost]
        public async Task<IActionResult> SendMessage([FromBody] SendMessageDto dto)
        {
            if (dto == null || string.IsNullOrWhiteSpace(dto.MessageText))
            {
                return BadRequest(new { message = "Invalid message data" });
            }

            var order = await _context.Orders.FindAsync(dto.ServiceRequestId);
            if (order == null)
            {
                return NotFound(new { message = "Order not found" });
            }

            // Prevent sending messages if the request is not accepted by a technician
            if (order.OrderStatus == OrderStatus.Pending)
            {
                return BadRequest(new { message = "Cannot send message before the order is accepted." });
            }

            var chatMsg = new ChatMessage
            {
                ServiceRequestId = dto.ServiceRequestId,
                SenderId = dto.SenderId,
                SenderName = dto.SenderName,
                MessageText = dto.MessageText,
                Timestamp = DateTime.UtcNow,
                IsRead = false
            };

            _context.ChatMessages.Add(chatMsg);
            await _context.SaveChangesAsync();

            // Notify both parties instantly via SignalR using the existing NotificationHub
            // We use the UserId and TechnicianName/TechnicianId groups
            var customerGroupId = order.UserId.ToString();
            await _hubContext.Clients.Group(customerGroupId).SendAsync("ReceiveChatMessage", chatMsg);

            // Also broadcast to technician if assigned
            // If the technician is an admin or technician role, they will be listening to their userId group
            // We also send to all users who might be viewing it or a broad serviceRequest group
            var techGroupId = order.TechnicianName ?? "technician"; // fallback or default group
            await _hubContext.Clients.Group(techGroupId).SendAsync("ReceiveChatMessage", chatMsg);
            
            // Also broadcast to a dedicated group for this specific order chat
            await _hubContext.Clients.Group($"order_chat_{dto.ServiceRequestId}").SendAsync("ReceiveChatMessage", chatMsg);

            return Ok(new { success = true, data = chatMsg });
        }
    }

    public class SendMessageDto
    {
        public int ServiceRequestId { get; set; }
        public int SenderId { get; set; }
        public string SenderName { get; set; } = string.Empty;
        public string MessageText { get; set; } = string.Empty;
    }
}
