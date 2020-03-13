using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using backApp.Moduls;

namespace backApp.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly bazaContext _context;

        public LoginController(bazaContext context)
        {
            _context = context;
        }

        // GET: api/Users
        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> GetUser()
        {
            return await _context.User.ToListAsync();
        }

        [HttpPost]
        public IActionResult Login([FromBody]User data)
        {
            var _db = new bazaContext();

            var x = _db.User.Where(pom => pom.Username.Equals(data.Username) && pom.Password.Equals(data.Password));
            if (x.Count() == 0)
            {
                return BadRequest();
            }
            return Ok(x);
        }

        private bool UserExists(long id)
        {
            return _context.User.Any(e => e.Id == id);
        }
    }
}
