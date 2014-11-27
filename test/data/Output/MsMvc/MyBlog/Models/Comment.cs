using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;


namespace MyBlog.Models
{
	public class Comment
	{
		public Guid CommentId { get; set; }
		public string CommentText { get; set; }
		Post Post { get; set; }
	}
}
