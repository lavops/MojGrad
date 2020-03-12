using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace API.Migrations
{
    public partial class firstHistory : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Histories",
                columns: table => new
                {
                    id = table.Column<int>(nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    datumRegistracije = table.Column<DateTime>(nullable: false),
                    useridUser = table.Column<int>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Histories", x => x.id);
                    table.ForeignKey(
                        name: "FK_Histories_Users_useridUser",
                        column: x => x.useridUser,
                        principalTable: "Users",
                        principalColumn: "idUser",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Histories_useridUser",
                table: "Histories",
                column: "useridUser");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Histories");
        }
    }
}
