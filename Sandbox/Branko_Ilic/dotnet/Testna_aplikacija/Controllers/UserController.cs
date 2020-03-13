using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Testna_aplikacija;

namespace Testna_aplikacija.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly UsersDBContext _context;

        public UserController(UsersDBContext context)
        {
            _context = context;
        }

        // GET: api/User
        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> GetUser()
        {
            return await _context.User.ToListAsync();
        }

        // GET: api/User/5
        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(long id)
        {
            var user = await _context.User.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            return user;
        }

        // PUT: api/User/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for
        // more details see https://aka.ms/RazorPagesCRUD.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(long id, User user)
        {
            if (id != user.id)
            {
                return BadRequest();
            }

            _context.Entry(user).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/User
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for
        // more details see https://aka.ms/RazorPagesCRUD.
        [HttpPost]
        public async Task<ActionResult<User>> PostUser(User user)
        {
            _context.User.Add(user);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUser", new { id = user.id }, user);
        }

        // DELETE: api/User/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<User>> DeleteUser(long id)
        {
            var user = await _context.User.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            _context.User.Remove(user);
            await _context.SaveChangesAsync();

            return user;
        }

        private bool UserExists(long id)
        {
            return _context.User.Any(e => e.id == id);
        }

        [HttpPost("Login")]
        public IActionResult Login([FromBody] User userParam)
        {
            var user = _context.User.SingleOrDefault(x => x.email == userParam.email);



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



            return Ok(user);
        }

        [HttpPost("Register")]
        public IActionResult Register([FromBody] User userParam)
        {
            var daLiPostojiEmail = _context.User.Where(em => em.email == userParam.email);

            if (!daLiPostojiEmail.Any())
            {
                User user = new User();
                user.email = userParam.email;
                user.password = userParam.password;
                user.username = userParam.username;
                user.firstName = userParam.firstName;
                user.lastName = userParam.lastName;
                _context.User.Add(user);
                _context.SaveChanges();

                return Ok(user);
            }
            else
            {
                return BadRequest(new { poruka = "Email vec postoji u bazi!" });
            }
        }
    }
}
