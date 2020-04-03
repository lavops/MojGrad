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
        List<Post> getAllPostsForOneUser(long id);
        Post getByID(long id);
        Post insertPost(Post post);

        List<Post> getAllSolvedPosts();
        List<Post> getAllUnsolvedPosts();

        bool deletePost(long id);

    }
}
