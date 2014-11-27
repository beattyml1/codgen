Create Database MyBlog

Create Table Posts (
  PostId UniqueIdentifier
  , ##:!IsLastTemplateInstance?
  PostTitle varchar(200)
  , ##:!IsLastTemplateInstance?
  PostText text
  , ##:!IsLastTemplateInstance?
)

Create Table Comments (
  CommentId UniqueIdentifier
  , ##:!IsLastTemplateInstance?
  CommentText text
  , ##:!IsLastTemplateInstance?
)
