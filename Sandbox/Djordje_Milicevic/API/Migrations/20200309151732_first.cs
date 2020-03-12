using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace API.Migrations
{
    public partial class first : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    idUser = table.Column<int>(nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    mail = table.Column<string>(nullable: true),
                    sifra = table.Column<string>(nullable: true),
                    korisnickoIme = table.Column<string>(nullable: true),
                    ime = table.Column<string>(nullable: true),
                    prezime = table.Column<string>(nullable: true),
                    datumRegistracije = table.Column<DateTime>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.idUser);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
