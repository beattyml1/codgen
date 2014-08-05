Create Database MyBlog

Create Table Posts (
  PostId UniqueIdentifier
  , 
  PostTitle varchar(200)
  , 
  PostText text
)

Create Table Comments (
  CommentId UniqueIdentifier
  , 
  CommentText text
)
