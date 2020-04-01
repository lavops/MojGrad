using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class UserViewModel
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
        public long cityId { get; set; }
        public long userTypeId { get; set; }
        public int points { get; set; }
        public int level { get; set; }

        public string userTypeName { get; set; }
        public string photoPath { get; set; }

        public UserViewModel(User u)
        {
            this.firstName = u.firstName;
            this.lastName = u.lastName;
            this.email = u.email;
            this.password = u.password;
            this.username = u.username;
            this.phone = u.phone;
            this.createdAt = u.createdAt;
            this.id = u.id;
            this.points = u.points;
            this.level = u.level;
            this.cityName = u.city.name;
            this.cityId = u.cityId;
            this.userTypeId = u.userTypeId;
            this.userTypeName = u.userTypes.typeName;
            this.photoPath = u.photo;
        }
    }
}
