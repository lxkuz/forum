class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def self.encode(payload, exp)
    jwt_params = { data: payload.to_json, exp: exp }
    JWT.encode(jwt_params, SECRET_KEY, 'HS256', { typ: 'JWT' })
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { typ: 'JWT', algorithm: 'HS256' })[0]
    HashWithIndifferentAccess.new JSON.parse(decoded['data'])
  end
end
