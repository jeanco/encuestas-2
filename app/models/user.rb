class User
  include Mongoid::Document
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :name,               type: String
  field :id_number,           type: String
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  #Savon gem test, works fine butt it's not enough
  def create_student (id)
    client = Savon.client(wsdl: "http://acadtest.ucaldas.edu.co:8084/wsClasesEstudiante.asmx?WSDL") #Connect to SOAP service
    response = client.call(:get_datos_estudiante, message: {codigo: id}) #Catch message from "get_datos_estudiante" with a user id
    noko_doc = Nokogiri::XML(response) #Parses this response to a Nokogiri document
    fuzzyName = noko_doc.xpath("//NOMBRES").to_s #Nokogiri search inside te huge string and return all values in "NOMBRES" tag
    User.create(name: fuzzyName[9..fuzzyName.size-11]) #Create a user from the SOAP data
  end

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
end
