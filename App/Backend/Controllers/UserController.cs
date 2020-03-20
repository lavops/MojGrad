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
        private AppDbContext contex = new AppDbContext();
        private readonly AppSettings _appSettings;

        public UserController(IOptions<AppSettings> appSettings)
        {
            _appSettings = appSettings.Value;
        }

        [HttpGet]
        public IEnumerable<user> GetUsers()
        {
            return contex.user.ToList();
        }


        [HttpPost("Login")]
        public IActionResult Login([FromBody] user userParam)
        {
            var user = contex.user.SingleOrDefault(x => x.email == userParam.email);

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
    }
}
