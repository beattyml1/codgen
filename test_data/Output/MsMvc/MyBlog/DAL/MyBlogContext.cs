using MyBlog.Models;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;

namespace MyBlog.DAL
{
    public class MyBlogContext : DbContext
    {
        public DbSet<Blog> Posts { get; set; }
        public DbSet<Blog> Comments { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {

        }
    }
}