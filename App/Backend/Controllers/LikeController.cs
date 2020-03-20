using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LikeController : ControllerBase
    {
        private readonly AppDbContext _context;
        public LikeController(AppDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        public IActionResult InsertLike(Like like)
        {
            Like like1 = new Like();

            like1.likeTypeId = like.likeTypeId;
            like1.userId = like.userId;
            like1.postId = like.postId;
            like1.time = DateTime.Now;

            int typeId = like.likeTypeId == 1 ? 2 : 1;
            Like like2 = _context.like.Where(x => x.likeTypeId == typeId && x.postId == like.postId && x.userId == like.userId).FirstOrDefault();

            if(like2 != null) //korisnik e vec dao suprotni lajk -- obrisati suprotni lajk i dodati prvi
            {
                _context.like.Remove(like2);
                _context.like.Add(like1);
                 _context.SaveChangesAsync();
            }
            else
            {
                Like like3 = _context.like.Where(x => x.postId == like.postId && x.userId == like.userId).FirstOrDefault();
                if(like3 == null)//ne postoji isti lajk pa se moze dodati u bazu
                {
                    _context.like.Add(like1);
                    _context.SaveChangesAsync();
                }
            }


            return Ok(like1);
            

        }
    }
}