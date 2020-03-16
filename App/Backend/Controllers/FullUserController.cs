using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FullUserController : ControllerBase
    {
        private readonly AppDbContext _context;
        public FullUserController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<user>>> GetUsers()
        {
            return await _context.user.ToListAsync();
        }

        // GET: api/FullUser/5
        [HttpGet("{id}")]
        public async Task<ActionResult<FullUser>> Getuser(long id)
        {
            var u = await _context.user.FindAsync(id);
            var c = await _context.city.FindAsync(u.cityId);
            var ful = new FullUser(u, c.name);

            if (u == null)
            {
                return NotFound();
            }

            return ful;
        }
    }
}