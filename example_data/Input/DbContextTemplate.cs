using {{ApplicationName}}.Models;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;

namespace {{ApplicationName}}.DAL
{
    public class {{ApplicationName}}Context : DbContext
    {
        <<< start entities >>>
        public DbSet<Blog> {{EntityNames}} { get; set; }
        <<< end entities >>>

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {

        }
    }
}