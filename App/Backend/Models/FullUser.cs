using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class FullUser
    {
        public long id { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string username { get; set; }
        public string password { get; set; }
        public string email { get; set; }
        public string phone { get; set; }
        public DateTime createdAt { get; set; }
        public string cityName { get; set; }

        public string userTypeName { get; set; }

        public FullUser(user u, string name, string typeName)
        {
            this.firstName = u.firstName;
            this.lastName = u.lastName;
            this.email = u.email;
            this.password = u.password;
            this.username = u.username;
            this.phone = u.phone;
            this.createdAt = u.createdAt;
            this.id = u.id;
            this.cityName = name;
            this.userTypeName = typeName;
        }
    }
}
