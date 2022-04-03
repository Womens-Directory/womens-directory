RSpec.describe UserPermissions do
  describe '.set_all!' do
    subject { described_class.set_all! current_user, params }

    context 'with a user who is not a superadmin' do
      let(:current_user) { User.new roles: [:user_editor] }
      let(:params) { { whatever: :doesnt_matter } }
      it "does not allow the user to change any user's permissions" do
        expect { subject }.to raise_error "Not authorized"
      end
    end

    context 'with a user who is a superadmin' do
      let(:current_user) { User.new roles: [:superadmin] }
      let!(:user_1) { User.create! id: 1, email: '1' }
      let!(:user_2) { User.create! id: 2, email: '2' }
      let!(:user_3) { User.create! id: 3, email: '3' }
      let!(:user_4) { User.create! id: 4, email: '4' }
      let(:params) do
        {
          '1-superadmin' => '1',
          '1-user_editor' => '0',
          '1-cms_editor' => '0',
          '1-data_editor' => '0',
          '1-data_contributor' => '0',

          '2-superadmin' => '0',
          '2-user_editor' => '1',
          '2-cms_editor' => '1',
          '2-data_editor' => '1',
          '2-data_contributor' => '0',

          '3-superadmin' => '0',
          '3-user_editor' => '0',
          '3-cms_editor' => '0',
          '3-data_editor' => '0',
          '3-data_contributor' => '1',

          '4-superadmin' => '0',
          '4-user_editor' => '0',
          '4-cms_editor' => '0',
          '4-data_editor' => '0',
          '4-data_contributor' => '0',
        }
      end

      it 'changes user permissions as expected' do
        expect { subject }
          .to change { user_1.reload.roles }.from([]).to(%i[superadmin])
          .and change { user_2.reload.roles }.from([]).to(%i[user_editor cms_editor data_editor])
          .and change { user_3.reload.roles }.from([]).to(%i[data_contributor])
          .and not_change { user_4.reload.roles }
      end

      context 'with invalid key' do
        let(:params) { { 'asdf-1234' => '1' } }
        it 'raises the expected error' do
          expect { subject }.to raise_error "Invalid key asdf-1234"
        end
      end

      context 'with invalid value' do
        let(:params) { { '2-user_editor' => 'true' } }
        it 'raises the expected error' do
          expect { subject }.to raise_error "Invalid value true"
        end
      end
    end
  end
end
