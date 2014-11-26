using System;
using System.Collections.Generic;
using System.Data.Entity.Spatial;
using System.ComponentModel.DataAnnotations.Schema;


namespace MyBlog.Models
{
	public class Post
	{
		public Guid PostId { get; set; }
		
		[Required] 
		[StringLength(200)] 
		public string PostTitle { get; set; }
		
		public string PostText { get; set; }
		
		ICollection<Comment> Comments { get; set; }
	}
}
