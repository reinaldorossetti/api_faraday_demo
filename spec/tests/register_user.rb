describe 'Realizando testes da feature de usuario.' do

  it 'Cadastrar usuário de teste, validando o json schema' do
    @response_create_user = Faraday.post('/usuarios') do |req|
      req.body = User.user_body
    end
    expect(@response_create_user.code).to eq 201
    p schema = JSON.parse(File.read($SCHEMA_JSON_REGISTER))
    JSON::Validator.validate!(schema, @response_create_user.body, strict: true)
  end

  it 'Cria, Pesquisa e Deleta usuario criado' do
    @response_create_user = Faraday.post('/usuarios', User.user_body)
    expect(@response_create_user.code).to eq 201

    result = JSON.parse(@response_create_user.body, object_class: OpenStruct)
    p @response_search = Http.get("/usuarios/#{result._id}")
    expect(@response_search.code).to eq 200

    @response_delete = Http.delete("/usuarios/#{result._id}")
    puts @response_delete.body
    expect(@response_delete.code).to eq 200
  end

  it 'Cria, Pesquisa e Altera o usuario criado' do
    @response_create_user = Http.post('/usuarios', User.user_body)
    expect(@response_create_user.code).to eq 201

    body_objects = JSON.parse(@response_create_user.body, object_class: OpenStruct)
    p @response_search = Http.get("/usuarios/#{body_objects._id}")
    expect(@response_search.code).to eq 200

    p @response_edit = Http.put("/usuarios/#{body_objects._id}", User.user_body)
    expect(@response_edit.code).to eq 200

    p @response_search = Http.get("/usuarios/#{body_objects._id}")
    expect(@response_search.code).to eq 200
  end

  it 'Validar regra de email usado, teste negativo' do
    @response_create_user = Http.post('/usuarios', User.user_body)
    expect(@response_create_user.code).to eq 201

    result = JSON.parse(@response_create_user.body, object_class: OpenStruct)
    p @response_search = Http.get("/usuarios/#{result._id}")
    expect(@response_search.code).to eq 200

    p @response_edit = Http.put("/usuarios/#{result._id}", User.user_body_email)
    expect(@response_edit.code).to eq 200

    p @response_search = Http.get("/usuarios/#{result._id}")
    expect(@response_search.code).to eq 200
  end

  it 'Lista usuários cadastrados' do
    @response_list_user = Http.get('/usuarios')
    expect(@response_list_user.code).to eq 200
  end

end
