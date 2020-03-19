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
    public class FullCommentController : ControllerBase
    {
         private readonly AppDbContext _context;
        public FullCommentController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public  ActionResult<IEnumerable<FullComment>> GetComments()
        {
            //  return await _context.user.ToListAsync();
            var comments =  _context.comment.Include(u => u.user).Include(p=> p.post).ToList(); //postovi jednog korisnika
            List<FullComment> comment = new List<FullComment>();
            foreach (var c in comments)
            {
                comment.Add(new FullComment(c));

            }

            if (comments == null)
            {
                return NotFound();
            }

            return comment;
        }

        [HttpGet("{id}")]
        public  ActionResult<IEnumerable<FullComment>> GetComm(long id) //vraca sve komentar za jedan post
        {
            var comments = _context.comment.Include(u => u.user).Include(p => p.post).Where(c=> c.postId==id).ToList(); //postovi jednog korisnika
            List<FullComment> comment = new List<FullComment>();
            foreach (var c in comments)
            {
                comment.Add(new FullComment(c));

            }

            if (comments == null)
            {
                return NotFound();
            }

            return comment;
        }


        [HttpPost]
        public IActionResult InsertComment(Comment k)
        {
            Comment kom = new Comment();
            kom.createdAt = DateTime.Now;
            kom.description = k.description;
            kom.postId = k.postId;
            kom.userId = k.userId;

            _context.comment.Add(kom);
            _context.SaveChanges();

            return Ok(kom);
           
        }


    }
}