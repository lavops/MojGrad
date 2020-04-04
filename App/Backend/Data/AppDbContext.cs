using Backend.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend
{
    public class AppDbContext:DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlite(@"Data source = database.db");
        }
        public DbSet<User> user { get; set; }
        public DbSet<City> city { get; set; }
        public DbSet<Comment> comment { get; set; }
        public DbSet<Like> like { get; set; }

        public DbSet<LikeType> likeType { get; set; }
        public DbSet<Post> post { get; set; }
        public DbSet<PostType> postType { get; set; }
        public DbSet<UserType> typeOfUser { get; set; }
        public DbSet<Status> status { get; set; }
        public DbSet<Report> report { get; set; }
        public DbSet<ReportType> reportType { get; set; }






    }
}
