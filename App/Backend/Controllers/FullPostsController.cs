using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    
    public class FullPostsController : ControllerBase
    {
        private readonly AppDbContext _context;
        public FullPostsController(AppDbContext context)
        {
            _context = context;
        }

        
        [HttpGet]
        public  ActionResult<IEnumerable<FullPost>> GetPosts()
        {
            //  return await _context.user.ToListAsync();
            var posts =  _context.post.Include(u => u.user).Include(s=> s.status).Include(po => po.postType).Include(l=> l.likes).Include(c=>c.comments).ToList(); //postovi jednog korisnika
            List<FullPost> post = new List<FullPost>();
            foreach (var p in posts)
            {
                post.Add(new FullPost(p));

            }

            if (posts == null)
            {
                return NotFound();
            }

            return post;
        }

       
        [HttpPost]
        public IActionResult InsertPost(Post post)
        {
            Post post1 = new Post();

            post1.userId = post.userId;
            post1.postTypeId = post.postTypeId;
            post1.createdAt = DateTime.Now;
            post1.description = post.description;
            post1.photoPath = post.photoPath;
            post1.statusId = post.statusId;

            if(post != null)
            {
                _context.post.Add(post1);
                _context.SaveChangesAsync();
                return Ok(post1);
            }
            else
            {
                return NoContent();
            }

            


        }


    }
}