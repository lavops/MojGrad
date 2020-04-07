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
            return _context.user.Include(x=> x.city).Include(s=> s.userTypes).Include(p=> p.posts).ToList();
        }

        public User getByID(long id)
        {
            return _context.user.Where((u) => u.id == id).Include(x => x.city).Include(s => s.userTypes).Include(p => p.posts).FirstOrDefault();
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

        public User editUserData(User user)
        {
            var exist = _context.user.Where(x => x.id == user.id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.firstName = user.firstName;
                    exist.lastName = user.lastName;
                    exist.username = user.username;
                    exist.email = user.email;
                    exist.phone = user.phone;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return exist;
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public string login(User user2)
        {
            var user = AuthenticateUser(user2);

            if (user != null)
            {
                var tokenStr = GenerateJSONWebToken(user);
                return tokenStr;
            }
            return null;
        }
        public User AuthenticateUser(User user)
        {
            var existingUser = _context.user.
                Where(k => k.email.Equals(user.email)
                    && k.password.Equals(user.password)).FirstOrDefault();
            return existingUser;
        }

        public string GenerateJSONWebToken(User user)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_appSettings.Secret));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.id.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti,Guid.NewGuid().ToString())
            };

            var token = new JwtSecurityToken(
                issuer: _appSettings.Secret,
                audience: _appSettings.Secret,
                claims,
                expires: DateTime.Now.AddDays(1),
                signingCredentials: credentials);

            var encodeToken = new JwtSecurityTokenHandler().WriteToken(token);
            return encodeToken;
        }

        public User editUserPassword(long id, string password, string newPassword)
        {
            var exist = _context.user.Where(x => x.id == id && x.password.Equals(password)).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.password = newPassword;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.user.Where((u) => u.id == id).Include(x => x.city).Include(s => s.userTypes).Include(p => p.posts).FirstOrDefault(); ;
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public bool deleteUser(long id)
        {
            var user = _context.user.Where(x=> x.id == id).FirstOrDefault();
            if (user == null)
            {
                return false;
            }

            _context.user.Remove(user);
            _context.SaveChangesAsync();

            return true;
        }

        public User editUserPhoto(long id, string photoPathn)
        {
            var exist = _context.user.Where(x => x.id == id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.photo = photoPathn;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.user.Where((u) => u.id == id).Include(x => x.city).Include(s => s.userTypes).Include(p => p.posts).FirstOrDefault();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }
    }
}
