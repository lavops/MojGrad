using Backend.DAL.Interfaces;
using Backend.Helpers;
using Backend.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class UserDAL : IUserDAL
    {
        private readonly AppDbContext _context;
        private readonly AppSettings _appSettings;
        public UserDAL (AppDbContext context, IOptions<AppSettings> appSettings)
        {
            _context = context;
            _appSettings = appSettings.Value;
        }

        public List<User> getAllUsers()
        {
            return _context.user.Include(x=> x.city).Include(s=> s.userTypes).ToList();
        }

        public User getByID(long id)
        {
            return _context.user.Where((u) => u.id == id).Include(x => x.city).Include(s => s.userTypes).FirstOrDefault();
        }


        public User insertUser(User user)
        {
            var exist = _context.user.Where(x => x.email == user.email).FirstOrDefault();
            if (exist == null)
            {
                var existUsername = _context.user.Where(x => x.username == user.username).FirstOrDefault();
                if (existUsername == null)
                {
                    User u1 = new User();
                    u1.email = user.email;
                    u1.createdAt = DateTime.Now;
                    u1.cityId = user.cityId;
                    u1.firstName = user.firstName;
                    u1.lastName = user.lastName;
                    u1.password = user.password;
                    u1.phone = user.phone;
                    u1.username = user.username;
                    u1.userTypeId = user.userTypeId;
                    u1.photo = "default.png";
                    u1.token = null;
                    u1.points = 0;
                    u1.level = 1;

                    _context.user.Add(u1);
                    _context.SaveChanges();

                    return u1;
                }
                else
                {
                    return null;
                }

            }
            else
            {
                return null;
            }
        }

        public User login(User user2)
        {
            var user1 = _context.user.SingleOrDefault(x => x.email == user2.email);

            if (user1 == null)
            {
                return null;
            }

            bool validPassword = false;

            if (user1 != null)
            {
                if (user2.password == user1.password)
                    validPassword = true;
            }

            if (validPassword == false)
            {
                return null;
            }

            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_appSettings.Secret);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, user1.id.ToString()),
                    new Claim("idUser", user1.id.ToString()),

                }),
                Expires = DateTime.UtcNow.AddDays(1),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);

            user1.token = tokenHandler.WriteToken(token);
            user1.password = null;

            return user1;
        }
    }
}
