using System.Threading;
using System.Threading.Tasks;
using CarMaintenance.DTOs;

namespace CarMaintenance.Services.Interfaces
{
    public interface IAdminActivityLogService
    {
        Task LogAsync(
            int adminUserId,
            string action,
            string description,
            string? targetType = null,
            int? targetId = null,
            string? ipAddress = null,
            CancellationToken cancellationToken = default);

        Task<PagedAdminActivityLogsResponseDto> GetLogsAsync(
            int page,
            int pageSize,
            CancellationToken cancellationToken = default);
    }
}
