using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using CarMaintenance.Services.Interfaces;
using CarMaintenance.DTOs;
using Swashbuckle.AspNetCore.Annotations;
using System.Threading.Tasks;

namespace CarMaintenance.Controllers
{
    [ApiController]
    [Route("api/admin/activity-logs")]
    [Authorize(Roles = "admin")]
    public class AdminActivityLogController : ControllerBase
    {
        private readonly IAdminActivityLogService _activityLogService;

        public AdminActivityLogController(IAdminActivityLogService activityLogService)
        {
            _activityLogService = activityLogService;
        }

        [HttpGet]
        [SwaggerOperation(Summary = "Get Admin Activity Logs")]
        public async Task<IActionResult> GetLogs([FromQuery] int page = 1, [FromQuery] int pageSize = 10)
        {
            var result = await _activityLogService.GetLogsAsync(page, pageSize);
            return Ok(result);
        }
    }
}
