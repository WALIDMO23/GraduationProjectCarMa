using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CarMaintenance.Data;
using CarMaintenance.Models;
using Microsoft.AspNetCore.Authorization;
using CarMaintenance.DTOs;
using System.Security.Claims;

namespace CarMaintenance.Controllers
{
    [ApiController]
    [Route("api/profile")]
    [Authorize]
    public class ProfileController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ProfileController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("me")]
        public async Task<IActionResult> GetMyProfile()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (userIdClaim == null)
                return Unauthorized();

            int userId = int.Parse(userIdClaim);

            var user = await _context.Users
                .FirstOrDefaultAsync(x => x.Id == userId);

            if (user == null)
                return NotFound();

            return Ok(new
            {
                user.Id,
                user.Name,
                user.Email,
                user.PhoneNumber,
                user.Role,
                ProfileImageUrl = user.ProfileImageData != null
                    ? $"{Request.Scheme}://{Request.Host}/api/profile/image/{user.Id}"
                    : (string?)null
            });
        }

        /// <summary>
        /// Serves the profile image directly from the database.
        /// AllowAnonymous so browser &lt;img&gt; tags can load it without a JWT header.
        /// </summary>
        [HttpGet("image/{userId}")]
        [AllowAnonymous]
        public async Task<IActionResult> GetProfileImage(int userId)
        {
            var user = await _context.Users
                .AsNoTracking()
                .Where(u => u.Id == userId)
                .Select(u => new { u.ProfileImageData, u.ProfileImageContentType })
                .FirstOrDefaultAsync();

            if (user?.ProfileImageData == null)
                return NotFound();

            return File(user.ProfileImageData, user.ProfileImageContentType ?? "image/jpeg");
        }

        [HttpPost("upload-image")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadProfileImage([FromForm] UploadImageDto dto)
        {
            if (dto.File == null || dto.File.Length == 0)
                return BadRequest("No file uploaded");

            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (userIdClaim == null)
                return Unauthorized();

            int userId = int.Parse(userIdClaim);

            var user = await _context.Users.FindAsync(userId);

            if (user == null)
                return NotFound();

            // Read the file into a byte array and store in the database
            using (var memoryStream = new MemoryStream())
            {
                await dto.File.CopyToAsync(memoryStream);
                user.ProfileImageData = memoryStream.ToArray();
            }

            user.ProfileImageContentType = dto.File.ContentType;

            await _context.SaveChangesAsync();

            var imageUrl =
                $"{Request.Scheme}://{Request.Host}/api/profile/image/{user.Id}";

            return Ok(new
            {
                message = "Profile image uploaded successfully",
                imageUrl
            });
        }

        [HttpPut("update")]
        public async Task<IActionResult> UpdateProfile(
            [FromBody] UpdateProfileDto dto)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (userIdClaim == null)
                return Unauthorized();

            int userId = int.Parse(userIdClaim);

            var user = await _context.Users.FindAsync(userId);

            if (user == null)
                return NotFound();

            user.Name = dto.Name;
            user.Email = dto.Email;
            user.PhoneNumber = dto.PhoneNumber;

            await _context.SaveChangesAsync();

            return Ok(new
            {
                user.Id,
                user.Name,
                user.Email,
                user.PhoneNumber,
                ProfileImageUrl = user.ProfileImageData != null
                    ? $"{Request.Scheme}://{Request.Host}/api/profile/image/{user.Id}"
                    : (string?)null
            });
        }
    }

    public class UploadImageDto
    {
        public IFormFile File { get; set; }
    }
}