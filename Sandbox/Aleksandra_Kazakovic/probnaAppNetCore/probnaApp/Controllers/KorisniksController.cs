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
    public class KorisniksController : ControllerBase
    {
        private readonly AppDbContext _context;

        public KorisniksController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Korisniks
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Korisnik>>> GetKorisnik()
        {
            return await _context.Korisnik.ToListAsync();
        }

        // GET: api/Korisniks/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Korisnik>> GetKorisnik(long id)
        {
            var korisnik = await _context.Korisnik.FindAsync(id);

            if (korisnik == null)
            {
                return NotFound();
            }

            return korisnik;
        }

        // PUT: api/Korisniks/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for
        // more details see https://aka.ms/RazorPagesCRUD.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutKorisnik(long id, Korisnik korisnik)
        {
            if (id != korisnik.id)
            {
                return BadRequest();
            }

            _context.Entry(korisnik).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!KorisnikExists(id))
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

        // POST: api/Korisniks
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for
        // more details see https://aka.ms/RazorPagesCRUD.
        
        [HttpPost]
        public async Task<ActionResult<Korisnik>> PostKorisnik(Korisnik korisnik)
        {
            _context.Korisnik.Add(korisnik);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetKorisnik", new { id = korisnik.id }, korisnik);
        }
        /*
        [HttpPost("Register")]
        public IActionResult Register(Korisnik k)
        {
            var daLiPostoji = _context.Korisnik.Where(e => e.email == k.email);
            if(!daLiPostoji.Any())
            {
                Korisnik kor = new Korisnik();
                kor.email = k.email;
                kor.ime = k.ime;
                kor.prezime = k.prezime;
                kor.sifra = k.sifra;

                _context.Korisnik.Add(kor);
                _context.SaveChanges();

                return Ok(kor);
            }
            else
            {
                return BadRequest(new { poruka = "Email vec postoji" });
            }
        }
        */
        // DELETE: api/Korisniks/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Korisnik>> DeleteKorisnik(long id)
        {
            var korisnik = await _context.Korisnik.FindAsync(id);
            if (korisnik == null)
            {
                return NotFound();
            }

            _context.Korisnik.Remove(korisnik);
            await _context.SaveChangesAsync();

            return korisnik;
        }

        private bool KorisnikExists(long id)
        {
            return _context.Korisnik.Any(e => e.id == id);
        }

        [Route("login")]
        [HttpPost]
        public async Task<ActionResult<bool>> ProveriLogin(Login login)
        {
            var korisnici = await _context.Korisnik.ToListAsync();
            var korisnik = korisnici.Where(k => k.sifra.Equals(login.sifra) && k.email.Equals(login.email)).FirstOrDefault();

            if (korisnik != null)
                return true;
            else
                return false;
        }
    }
}
