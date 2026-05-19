using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace CarMaintenance.Migrations
{
    /// <inheritdoc />
    public partial class StoreProfileImageInDatabase : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ServiceWorkshop_Workshop_WorkshopsId",
                table: "ServiceWorkshop");

            migrationBuilder.DropUniqueConstraint(
                name: "AK_Workshop_TempId",
                table: "Workshop");

            migrationBuilder.RenameTable(
                name: "Workshop",
                newName: "Workshops");

            migrationBuilder.RenameColumn(
                name: "ProfileImageUrl",
                table: "Users",
                newName: "ProfileImageContentType");

            migrationBuilder.RenameColumn(
                name: "TempId",
                table: "Workshops",
                newName: "TotalOrders");

            migrationBuilder.AddColumn<byte[]>(
                name: "ProfileImageData",
                table: "Users",
                type: "bytea",
                nullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "WorkshopsId",
                table: "ServiceWorkshop",
                type: "integer",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "integer",
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "ServicesId",
                table: "ServiceWorkshop",
                type: "integer",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "integer",
                oldNullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "Workshops",
                type: "integer",
                nullable: false,
                defaultValue: 0)
                .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn);

            migrationBuilder.AddColumn<string>(
                name: "Address",
                table: "Workshops",
                type: "character varying(500)",
                maxLength: 500,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<TimeSpan>(
                name: "CloseTime",
                table: "Workshops",
                type: "interval",
                nullable: false,
                defaultValue: new TimeSpan(0, 0, 0, 0, 0));

            migrationBuilder.AddColumn<DateTime>(
                name: "CreatedAt",
                table: "Workshops",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "Email",
                table: "Workshops",
                type: "character varying(200)",
                maxLength: 200,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "Workshops",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsOpen",
                table: "Workshops",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "JoinDate",
                table: "Workshops",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "Name",
                table: "Workshops",
                type: "character varying(200)",
                maxLength: 200,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<TimeSpan>(
                name: "OpenTime",
                table: "Workshops",
                type: "interval",
                nullable: false,
                defaultValue: new TimeSpan(0, 0, 0, 0, 0));

            migrationBuilder.AddColumn<string>(
                name: "OwnerName",
                table: "Workshops",
                type: "character varying(200)",
                maxLength: 200,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "PhoneNumber",
                table: "Workshops",
                type: "character varying(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ServiceWorkshop",
                table: "ServiceWorkshop",
                columns: new[] { "ServicesId", "WorkshopsId" });

            migrationBuilder.AddPrimaryKey(
                name: "PK_Workshops",
                table: "Workshops",
                column: "Id");

            migrationBuilder.CreateIndex(
                name: "IX_ServiceWorkshop_WorkshopsId",
                table: "ServiceWorkshop",
                column: "WorkshopsId");

            migrationBuilder.CreateIndex(
                name: "IX_Workshops_Email",
                table: "Workshops",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Workshops_IsActive",
                table: "Workshops",
                column: "IsActive");

            migrationBuilder.CreateIndex(
                name: "IX_Workshops_IsOpen",
                table: "Workshops",
                column: "IsOpen");

            migrationBuilder.AddForeignKey(
                name: "FK_ServiceWorkshop_Workshops_WorkshopsId",
                table: "ServiceWorkshop",
                column: "WorkshopsId",
                principalTable: "Workshops",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ServiceWorkshop_Workshops_WorkshopsId",
                table: "ServiceWorkshop");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ServiceWorkshop",
                table: "ServiceWorkshop");

            migrationBuilder.DropIndex(
                name: "IX_ServiceWorkshop_WorkshopsId",
                table: "ServiceWorkshop");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Workshops",
                table: "Workshops");

            migrationBuilder.DropIndex(
                name: "IX_Workshops_Email",
                table: "Workshops");

            migrationBuilder.DropIndex(
                name: "IX_Workshops_IsActive",
                table: "Workshops");

            migrationBuilder.DropIndex(
                name: "IX_Workshops_IsOpen",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "ProfileImageData",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "Address",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "CloseTime",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "CreatedAt",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "Email",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "IsOpen",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "JoinDate",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "Name",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "OpenTime",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "OwnerName",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "PhoneNumber",
                table: "Workshops");

            migrationBuilder.RenameTable(
                name: "Workshops",
                newName: "Workshop");

            migrationBuilder.RenameColumn(
                name: "ProfileImageContentType",
                table: "Users",
                newName: "ProfileImageUrl");

            migrationBuilder.RenameColumn(
                name: "TotalOrders",
                table: "Workshop",
                newName: "TempId");

            migrationBuilder.AlterColumn<int>(
                name: "WorkshopsId",
                table: "ServiceWorkshop",
                type: "integer",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.AlterColumn<int>(
                name: "ServicesId",
                table: "ServiceWorkshop",
                type: "integer",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.AddUniqueConstraint(
                name: "AK_Workshop_TempId",
                table: "Workshop",
                column: "TempId");

            migrationBuilder.AddForeignKey(
                name: "FK_ServiceWorkshop_Workshop_WorkshopsId",
                table: "ServiceWorkshop",
                column: "WorkshopsId",
                principalTable: "Workshop",
                principalColumn: "TempId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
