using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class FullComment
    {
        public long id { get; set; }
        public long postId { get; set; }
        public long userId { get; set; }
        public DateTime createdAt { get; set; }
        public string description { get; set; }
        public string username { get; set; }

        public FullComment(Comment com)
        {
            this.description = com.description;
            this.id = com.id;
            this.postId = com.postId;
            this.userId = com.userId;
            this.username = com.user.username;
        }

    }
}
