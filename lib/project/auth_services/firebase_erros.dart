String getErrorString(String code) {
  switch (code) {
    case 'ERROR_WRONG_PASSWORD':
      return 'Sua senha está incorreta.';
    case 'ERROR_INVALID_CUSTOM_TOKEN':
      return 'Seu token personalizado é inválido.';
    case 'ERROR_CUSTOM_TOKEN_MISMATCH':
      return 'O token personalizado não corresponde ao seu usuário.';
    case 'ERROR_INVALID_CREDENTIAL':
      return 'Sua credencial é inválida.';
    case 'ERROR_INVALID_EMAIL':
      return 'Seu e-mail é inválido.';
    case 'ERROR_USER_NOT_FOUND':
      return 'Não encontramos um usuário com este e-mail.';
    case 'ERROR_USER_DISABLED':
      return 'Este usuário foi desabilitado.';
    case 'ERROR_TOO_MANY_REQUESTS':
      return 'Muitas solicitações. Tente novamente mais tarde.';
    case 'ERROR_OPERATION_NOT_ALLOWED':
      return 'Esta operação não é permitida.';
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      return 'Este e-mail já está em uso por outra conta.';
    case 'ERROR_INVALID_USER_TOKEN':
      return 'Seu token de usuário é inválido.';
    case 'ERROR_TOKEN_EXPIRED':
      return 'Seu token expirou.';
    case 'ERROR_SESSION_EXPIRED':
      return 'Sua sessão expirou. Faça login novamente.';
    case 'ERROR_SIGN_IN_REQUIRED':
      return 'É necessário fazer login para realizar esta ação.';
    case 'ERROR_INVALID_IDP_RESPONSE':
      return 'A resposta do provedor de identidade é inválida.';
    case 'ERROR_NO_SUCH_PROVIDER':
      return 'Este provedor não existe.';
    case 'ERROR_USER_MISMATCH':
      return 'O usuário não corresponde ao provedor de identidade.';
    case 'ERROR_REQUIRES_RECENT_LOGIN':
      return 'É necessário fazer login recentemente para realizar esta ação.';
    case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
      return 'Já existe uma conta com este e-mail em outro provedor.';
    case 'ERROR_CREDENTIAL_ALREADY_IN_USE':
      return 'Esta credencial já está em uso por outro usuário.';
    case 'ERROR_USER_CANCELLED':
      return 'Você cancelou a operação.';
    case 'ERROR_APP_NOT_AUTHORIZED':
      return 'O aplicativo não está autorizado a usar o Firebase Authentication.';
    case 'ERROR_NETWORK_ERROR':
      return 'Erro de rede. Verifique sua conexão e tente novamente.';
    case 'ERROR_UNKNOWN':
      return 'Ocorreu um erro desconhecido. Tente novamente mais tarde.';
    case 'ERROR_WEAK_PASSWORD':
      return 'Sua senha é muito fraca. Escolha uma senha mais forte.';
    case 'email-already-in-use':
      return 'Este e-mail já está em uso por outra conta.';
    default:
      return 'Ocorreu um erro inesperado. Tente novamente mais tarde.';
  }
}
