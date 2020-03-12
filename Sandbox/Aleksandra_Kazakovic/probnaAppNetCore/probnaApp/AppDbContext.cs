using Microsoft.EntityFrameworkCore;
using probnaApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace probnaApp
{
    public class AppDbContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlite(@"Data source = baza.db");
        }
        public DbSet<Korisnik> Korisnik { get; set; }
       // public DbSet<Autor> Autor { get; set; }
        public DbSet<Knjige> Knjige { get; set; }


    }
}
