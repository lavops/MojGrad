using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IPostBL
    {
        List<Post> getAllPosts();
        List<Post> getAllPostsForOneUser(long id);
        Post getByID(long id);
        Post insertPost(Post post);
        List<Post> getAllSolvedPosts();
        List<Post> getAllUnsolvedPosts();
    }
}
