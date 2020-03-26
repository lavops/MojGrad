using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Backend.Helpers;
using Backend.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private AppDbContext _context = new AppDbContext();
        private readonly AppSettings _appSettings;

       
        public UserController(IOptions<AppSettings> appSettings)
        {
            _appSettings = appSettings.Value;
        }

        [HttpGet]
        public IEnumerable<user> GetUsers()
        {
            return _context.user.ToList();
        }

         [HttpGet("{id}")]
        public async Task<ActionResult<FullUser>> Getuser(long id)
        {
            var user = await _context.user.FindAsync(id);
            var c = await _context.city.FindAsync(user.cityId);
            var type = await _context.typeOfUser.FindAsync(user.userTypeId);
            var userWhitCity = new FullUser(user, c.name, type.typeName);

            if (user == null)
            {
                return NotFound();
            }

            return userWhitCity;
        }

        [HttpPost("Login")]
        public IActionResult Login([FromBody] user userParam)
        {
            var user = _context.user.SingleOrDefault(x => x.email == userParam.email);

            if (user == null)
            {
                return BadRequest(new { poruka = "Nevalidni podaci" });
            }

            bool validPassword = false;

            if (user != null)
            {
                if (userParam.password == user.password)
                    validPassword = true;
            }

            if (validPassword == false)
            {
                return BadRequest(new { poruka = "Nevalidni podaci" });
            }

            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_appSettings.Secret);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, user.id.ToString()),
                    new Claim("idUser", user.id.ToString()),

                }),
                Expires = DateTime.UtcNow.AddDays(1),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);

            user.token = tokenHandler.WriteToken(token);
            user.password = null;

            return Ok(user);
        }

        [HttpPost("Register")]
        public IActionResult Register(user u)
        {
            var exist = _context.user.Where(x=> x.email==u.email).FirstOrDefault();
            if (exist == null)
            {
                var existUsername = _context.user.Where(x => x.username == u.username).FirstOrDefault();
                if (existUsername == null)
                {
                    user u1 = new user();
                    u1.email = u.email;
                    u1.createdAt = DateTime.Now;
                    u1.cityId = u.cityId;
                    u1.firstName = u.firstName;
                    u1.lastName = u.lastName;
                    u1.password = u.password;
                    u1.phone = u.phone;
                    u1.username = u.username;
                    u1.userTypeId = u.userTypeId;
                    u1.photo = "default.png";
                    u1.token = null;

                    _context.user.Add(u1);
                    _context.SaveChanges();

                    return Ok(u1);
                }
                else
                {
                    return BadRequest(new { poruka = "Username vec postoji" });
                }

            }
            else
            {
                return BadRequest(new { poruka = "Email vec postoji" });
            }
        }
    }
}
