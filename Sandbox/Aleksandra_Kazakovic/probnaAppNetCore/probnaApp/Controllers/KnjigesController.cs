using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using probnaApp;
using probnaApp.Models;

namespace probnaApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KnjigesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public KnjigesController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Knjiges
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Knjige>>> GetKnjige()
        {
            return await _context.Knjige.ToListAsync();
        }

        // GET: api/Knjiges/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Knjige>> GetKnjige(long id)
        {
            var knjige = await _context.Knjige.FindAsync(id);

            if (knjige == null)
            {
                return NotFound();
            }

            return knjige;
        }

        // PUT: api/Knjiges/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for
        // more details see https://aka.ms/RazorPagesCRUD.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutKnjige(long id, Knjige knjige)
        {
            if (id != knjige.id)
            {
                return BadRequest();
            }

            _context.Entry(knjige).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!KnjigeExists(id))
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

        // POST: api/Knjiges
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for
        // more details see https://aka.ms/RazorPagesCRUD.
        [HttpPost]
        public async Task<ActionResult<Knjige>> PostKnjige(Knjige knjige)
        {
            _context.Knjige.Add(knjige);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetKnjige", new { id = knjige.id }, knjige);
        }

        // DELETE: api/Knjiges/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Knjige>> DeleteKnjige(long id)
        {
            var knjige = await _context.Knjige.FindAsync(id);
            if (knjige == null)
            {
                return NotFound();
            }

            _context.Knjige.Remove(knjige);
            await _context.SaveChangesAsync();

            return knjige;
        }

        private bool KnjigeExists(long id)
        {
            return _context.Knjige.Any(e => e.id == id);
        }
    }
}
