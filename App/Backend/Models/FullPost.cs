using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class FullPost
    {
       
        public long postId { get; set; }
        public long userId { get; set; }
        public string username { get; set; }
        public long postTypeId { get; set; }
        public string typeName { get; set; }
        public DateTime createdAt { get; set; }
        public string description { get; set; }
        public string photoPath { get; set; }
        public long statusId { get; set; }
        public string status { get; set; }
        public int likeNum { get; set; }
        public int dislikeNum { get; set; }

        public FullPost(Post p) //post se posalje
        {
            this.username = p.user.username;
            this.createdAt = p.createdAt;
            this.description = p.description;
            this.dislikeNum = p.likes.Count(x => x.likeTypeId == 1);
            this.likeNum = p.likes.Count(x => x.likeTypeId == 2);
            this.photoPath = p.photoPath;
            this.postId = p.id;
            this.postTypeId = p.postTypeId;
            this.status = p.status.type;
            this.statusId = p.statusId;
            this.userId = p.userId;
            this.typeName = p.postType.typeName;
          
            
           
        }


    }
}
