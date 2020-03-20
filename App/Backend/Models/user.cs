using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class user
    {
        public long id { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string username { get; set; }
        public string password { get; set; }
        public string email { get; set; }
        public string phone { get; set; }
        public DateTime createdAt { get; set; }
        public long cityId { get; set; }
        public string location { get; set; }
        public string photo { get; set; }
        public string token { get; set; }

        public virtual City city { get; set; }
        public IList<Like> likes { get; set; }
        public IList<Post> posts { get; set; }
        public IList<Comment> comments { get; set; }

    }
}
