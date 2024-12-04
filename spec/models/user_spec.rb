require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録できる場合' do
      it "nameとemail、passwordとpassword_confirmationが存在すれば登録できる" do
        expect(@user).to be_valid

      end
    end
    context '新規登録できない場合' do
      it '重複したemailが存在する場合は登録できない' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Email has already been taken')
      end

      it 'emailは@を含まないと登録できない' do
        @user.email = 'testmail'
        @user.valid?
        expect(@user.errors.full_messages).to include('Email is invalid')
      end

      it "nameが空では登録できない" do
        @room.name = ''
        @room.valid?
        expect(@room.errors.full_messages).to include("Name can't be blank")
      end
      it 'passwordが5文字以下では登録できない' do
        @user.password = '12345'
        @user.password_confirmation = '12345'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end

      it 'passwordが129文字以上では登録できない' do
        @user.password =  Faker::Internet.password(min_length: 129, max_length: 150)
        @user.password_confirmation =  @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too long (maximum is 128 characters)')
      end

      it 'passwordとpassword_confirmationが不一致では登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '1234567'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end

      it "emailが空では登録できない" do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it "passwordが空では登録できない" do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end

      describe 'メッセージ投稿' do
        context 'メッセージが投稿できる場合' do
          it 'contentとimageが存在していれば保存できる' do
            expect(@message).to be_valid
          end
          it 'contentが空でも保存できる' do
            @message.content = ''
            expect(@message).to be_valid
          end
          it 'imageが空でも保存できる' do
            @message.image = nil
            expect(@message).to be_valid
          end
        end
        context 'メッセージが投稿できない場合' do
          it 'contentとimageが空では保存できない' do
            @message.content = ''
            @message.image = nil
            @message.valid?
            expect(@message.errors.full_messages).to include("Content can't be blank")
          end
          it 'roomが紐付いていないと保存できない' do
            @message.room = nil
            @message.valid?
            expect(@message.errors.full_messages).to include('Room must exist')
          end
          it 'userが紐付いていないと保存できない' do
            @message.user = nil
            @message.valid?
            expect(@message.errors.full_messages).to include('User must exist')
          end
    end
  end
end