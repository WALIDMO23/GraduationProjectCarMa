[HttpGet("menu")]
public IActionResult GetProfileMenu()
{
    var menu = new[]
    {
        new
        {
            title = "الملف الشخصي",
            route = "/admin/profile"
        },
        new
        {
            title = "الإعدادات",
            route = "/admin/settings"
        }
    };

    return Ok(menu);
}