using API.Models;
using API.Data;
using API.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using System.IdentityModel.Tokens.Jwt;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private bazaContext contex = new bazaContext();
        private readonly AppSettings _appSettings;

        public UserController(IOptions<AppSettings> appSettings)
        {
            _appSettings = appSettings.Value;
        }
        // GET: api/User
        [HttpGet]
        public IEnumerable<User> GetUsers()
        {
            return contex.Users.ToList();
        }

        [HttpPost("Login")]
        public IActionResult Login([FromBody] User userParam)
        {
            var user = contex.Users.SingleOrDefault(x => x.mail == userParam.mail);

            //* Dodavanje u istoriju *//
            History istorija = new History();
            istorija.datumRegistracije = DateTime.Now;
            istorija.user = user;

            contex.Histories.Add(istorija);
            contex.SaveChanges();

            if (user == null)
            {
                return BadRequest(new { poruka = "Nevalidni podaci" });
            }

            bool validPassword = false;

            if (user != null)
            {
                if (userParam.sifra == user.sifra)
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
                    new Claim(ClaimTypes.Name, user.idUser.ToString()),
                    new Claim("idUser", user.idUser.ToString()),

                }),
                Expires = DateTime.UtcNow.AddDays(1),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);

            user.token = tokenHandler.WriteToken(token);
            user.sifra = null;

            return Ok(user);
        }

        [HttpPost("Register")]
        public IActionResult Register([FromBody] User userParam)
        {
            var daLiPostojiEmail = contex.Users.Where(em => em.mail == userParam.mail);

            if (!daLiPostojiEmail.Any())
            {
                User user = new User();
                user.mail = userParam.mail;
                user.sifra = userParam.sifra;
                user.korisnickoIme = userParam.korisnickoIme;
                user.ime = userParam.ime;
                user.prezime = userParam.prezime;
                user.datumRegistracije = DateTime.Today;

                contex.Users.Add(user);
                contex.SaveChanges();

                return Ok(user);
            }
            else
            {
                return BadRequest(new { poruka = "Email vec postoji u bazi!" });
            }
        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
            var user = contex.Users.Where(x => x.idUser == id).FirstOrDefault();
            contex.Users.Remove(user);
            contex.SaveChanges();
        }
    }
}
