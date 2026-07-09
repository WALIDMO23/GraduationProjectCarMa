using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace CarMaintenance.Migrations
{
    /// <inheritdoc />
    public partial class AddSubServices : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "SubServiceId",
                table: "Orders",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "SubServices",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    ServiceId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SubServices", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SubServices_Services_ServiceId",
                        column: x => x.ServiceId,
                        principalTable: "Services",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "SubServices",
                columns: new[] { "Id", "Name", "ServiceId" },
                values: new object[,]
                {
                    { 1, "شحن", 2 },
                    { 2, "تغيير", 2 },
                    { 3, "شراء", 2 },
                    { 4, "تغيير زيت محرك", 1 },
                    { 5, "تغيير زيت فتيس", 1 },
                    { 6, "فحص مستوي الزيت", 1 },
                    { 7, "نفخ", 3 },
                    { 8, "تغيير", 3 },
                    { 9, "لحام", 3 },
                    { 10, "خارجي وداخلي", 4 },
                    { 11, "خارجي", 4 },
                    { 12, "تنظيف جاف", 4 },
                    { 13, "ميكانيكا وكهربا سريعه", 5 },
                    { 14, "توصيل وقود بنزين", 5 },
                    { 15, "فتح ابواب السياره", 5 },
                    { 16, "ونش انقاذ مسطح", 6 },
                    { 17, "ونش سحب", 6 },
                    { 18, "ونش هيدروليك", 6 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Orders_SubServiceId",
                table: "Orders",
                column: "SubServiceId");

            migrationBuilder.CreateIndex(
                name: "IX_SubServices_ServiceId",
                table: "SubServices",
                column: "ServiceId");

            migrationBuilder.AddForeignKey(
                name: "FK_Orders_SubServices_SubServiceId",
                table: "Orders",
                column: "SubServiceId",
                principalTable: "SubServices",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Orders_SubServices_SubServiceId",
                table: "Orders");

            migrationBuilder.DropTable(
                name: "SubServices");

            migrationBuilder.DropIndex(
                name: "IX_Orders_SubServiceId",
                table: "Orders");

            migrationBuilder.DropColumn(
                name: "SubServiceId",
                table: "Orders");
        }
    }
}
