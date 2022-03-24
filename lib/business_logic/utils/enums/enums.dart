enum ViewState { Ideal, Busy }
enum AuthState { SignIn, SignUp }

/// In Sign Up Screen
enum SignUpState {
  ALREADY_HAVE_ACCOUNT,
  WEAK_PASSWORD,
  UNKNOWN_ERROR,
  SIGN_UP_SUCCESS,
  PASSWORD_NOT_SAME,
  VALIDATED_FALSE,
  VALIDATED_TRUE,
  SELECT_IMAGE
}

/// In Sign In Screen
enum SignInState {
  WRONG_PASSWORD,
  USER_NOT_FOUND,
  UNKNOWN_ERROR,
  SIGN_IN_SUCCESS,
  INVALID_EMAIL
}

/// Upload post state
enum UploadPostState { POST_UPLOADED, UNKNOWN_ERROR }

/// Upload comment state

enum UploadCommentState { COMMENT_POSTED, UNKNOWN_ERROR }

/// Comment Like State
enum LikePostState { POST_LIKED, UNKNOWN_ERROR }

/// post deleted state

enum DeletePostState { POST_DELETED, UNKNOWN_ERROR }

/// saved to bookmark

enum SavedToBookMarkState { SAVED_TO_BOOKMARK, UNKNOWN_ERROR }


/// follow user state

enum FollowUserState {

  USER_FOLLOWED,
  UNKNOWN_ERROR
}


enum UPLOAD_VIDEO_STATE {


  VIDEO_UPLOADED,
  VIDEO_UPLOADED_FAILED
}