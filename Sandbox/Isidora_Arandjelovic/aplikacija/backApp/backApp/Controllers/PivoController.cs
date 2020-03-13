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
    public class PivoController : ControllerBase
    {
        private readonly bazaContext _context;

        public PivoController(bazaContext context)
        {
            _context = context;
        }

        // GET: api/Users
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Pivo>>> GetPivo()
        {
            return await _context.Pivo.ToListAsync();
        }

        private bool PivoExists(long id)
        {
            return _context.Pivo.Any(e => e.id == id);
        }
    }
}
