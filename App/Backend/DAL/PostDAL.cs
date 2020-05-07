using Backend.DAL.Interfaces;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class PostDAL : IPostDAL
    {
        private readonly AppDbContext _context;

        public PostDAL(AppDbContext context)
        {
            _context = context;
        }

        public bool deletePost(long id)
        {
            var post = _context.post.Where(x => x.id == id).FirstOrDefault();
            if (post == null)
            {
                return false;
            }

            _context.post.Remove(post);
            _context.SaveChangesAsync();

            return true;
        }

        public Post editPost(long id, string description)
        {
            var exist = _context.post.Where(x => x.id == id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.description = description;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.post.Where((u) => u.id == id).Include(u => u.user).Include(s => s.status).Include(po => po.postType).Include(l => l.likes).Include(c => c.comments).FirstOrDefault();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public List<Post> getAllPosts()
        {
            return _context.post.Include(u => u.user).Include(c=> c.postType).Include(s=>s.status).Include(l => l.likes).Include(c => c.comments).Include(c=> c.city).OrderByDescending(x=>x.id).ToList();
        }

        public List<Post> getAllPostsByCityId(long cityId)
        {
            return _context.post.Where(c=> c.cityId == cityId).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).Include(c => c.city).OrderByDescending(x => x.id).ToList();
        }

        public List<Post> getAllPostsSolvedByOneInstitution(long id)
        {
            var solutions = _context.challengeSolving.Where(x => x.institutionId == id && x.selected == 1).ToList();
            List<Post> listPosts = new List<Post>();

            foreach (var sol in solutions)
            {
                var post = _context.post.Where(x => x.id == sol.postId).Include(u => u.user).Include(s => s.status).Include(po => po.postType).Include(l => l.likes).Include(c => c.comments).Include(c => c.city).FirstOrDefault();
                listPosts.Add(post);
            }

            listPosts.OrderByDescending(x => x.id);
            return listPosts;
            
        }

        public List<Post> getAllPostsForOneUser(long id)
        {
            return _context.post.Where(x => x.userId == id).Include(u => u.user).Include(s => s.status).Include(po => po.postType).Include(l => l.likes).Include(c => c.comments).Include(c => c.city).OrderByDescending(x => x.id).ToList();
        }

        public List<Post> getAllSolvedPosts()
        {
            return _context.post.Where(x=> x.statusId==1).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).OrderByDescending(x => x.id).Include(c => c.city).ToList();
        }

        public List<Post> getAllSolvedPostsByCityId(long cityId)
        {
            return _context.post.Where(x => x.statusId == 1 && x.cityId == cityId).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).OrderByDescending(x => x.id).Include(c => c.city).ToList();
        }

        public List<Post> getAllUnsolvedPosts()
        {
            return _context.post.Where(x => x.statusId == 2).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).Include(s => s.status).Include(c => c.city).Include(l => l.likes).Include(c => c.comments).OrderByDescending(x => x.id).ToList();
        }

        public List<Post> getAllUnsolvedPostsByCityId(long cityId)
        {
            return _context.post.Where(x => x.statusId == 2 && x.cityId == cityId).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).Include(s => s.status).Include(c => c.city).Include(l => l.likes).Include(c => c.comments).OrderByDescending(x => x.id).ToList();
        }

        public Post getByID(long id)
        {
            return _context.post.Where(x => x.id == id).Include(u => u.user).Include(s => s.status).Include(po => po.postType).Include(l => l.likes).Include(c => c.comments).Include(c => c.city).FirstOrDefault();
        }

        public Post insertPost(Post post)
        {
            Post post1 = new Post();

            post1.userId = post.userId;
            post1.postTypeId = post.postTypeId;
            post1.createdAt = DateTime.Now;
            post1.description = post.description;
            post1.photoPath = post.photoPath;
            post1.address = post.address;
            post1.statusId = post.statusId;
            post1.latitude = post.latitude;
            post1.longitude = post.longitude;
            post1.cityId = post.cityId;

            if (post != null)
            {
                _context.post.Add(post1);
                _context.SaveChangesAsync();
                return post1;
            }
            else
            {
                return null;
            }

        }

     
    }
}
