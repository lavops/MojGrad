using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IPostDAL
    {
        List<Post> getAllPosts();
        List<Post> getAllPostsByCityId(long cityId);
        List<Post> getAllPostsForOneUser(long id);
        Post getByID(long id);
        Post insertPost(Post post);
        List<Post> getAllSolvedPosts();
        List<Post> getAllUnsolvedPosts();
        List<Post> getAllSolvedPostsByCityId(long cityId);
        List<Post> getAllUnsolvedPostsByCityId(long cityId);
        bool deletePost(long id);
        Post editPost(long id, string description);

    }
}
