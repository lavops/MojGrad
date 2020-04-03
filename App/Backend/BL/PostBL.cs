using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class PostBL : IPostBL
    {
        private readonly IPostDAL _iPostDAL;

        public PostBL(IPostDAL iPostDAL)
        {
            _iPostDAL = iPostDAL;
        }

        public bool deletePost(long id)
        {
            return _iPostDAL.deletePost(id);
        }

        public List<Post> getAllPosts()
        {
            return _iPostDAL.getAllPosts();
        }

        public List<Post> getAllPostsForOneUser(long id)
        {
            return _iPostDAL.getAllPostsForOneUser(id);
        }

        public List<Post> getAllSolvedPosts()
        {
            return _iPostDAL.getAllSolvedPosts();
        }

        public List<Post> getAllUnsolvedPosts()
        {
            return _iPostDAL.getAllUnsolvedPosts();
        }

        public Post getByID(long id)
        {
            return _iPostDAL.getByID(id);
        }

        public Post insertPost(Post post)
        {
            return _iPostDAL.insertPost(post);
        }
    }
}
