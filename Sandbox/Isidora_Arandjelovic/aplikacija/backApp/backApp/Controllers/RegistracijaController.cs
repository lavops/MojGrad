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
    public class RegistracijaController : ControllerBase
    {
        private readonly bazaContext _context;

        public RegistracijaController(bazaContext context)
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
        public IActionResult Reg([FromBody]User data)
        {
            var _db = new bazaContext();
            data.Id = _db.User.Count() + 1;
            if (data == null)
            {
                return BadRequest();
            }
            _db.User.Add(data);
            _db.SaveChanges();

            return Ok(data);
        }

        private bool UserExists(long id)
        {
            return _context.User.Any(e => e.Id == id);
        }
    }
}
