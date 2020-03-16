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
        public string createdAt { get; set; }
        public string cityName { get; set; }

        public FullUser(user u, string name)
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
        }
    }
}
