using Backend.DAL.Interfaces;
using Backend.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class CommentDAL : ICommentDAL
    {
        private readonly AppDbContext _context;

        public CommentDAL(AppDbContext context)
        {
            _context = context;
        }

        public Comment getByID(long id)
        {
            return _context.comment.Where(c => c.id == id).FirstOrDefault();
        }

        public List<Comment> getCommentsForPost(long id)
        {
            return _context.comment.Include(x => x.user).Include(p => p.post).ToList();
        }

        public Comment insertComment(Comment comment)
        {
            Comment com = new Comment();
            com.createdAt = DateTime.Now;
            com.description = comment.description;
            com.postId = comment.postId;
            com.userId = comment.userId;

            _context.comment.Add(com);
            _context.SaveChanges();

            return com;
        }
    }
}
