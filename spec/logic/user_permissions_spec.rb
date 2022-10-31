RSpec.describe UserPermissions do
  describe '.set_all!' do
    subject { described_class.set_all! current_user, params }

    context 'with a user who is not a superadmin' do
      let(:current_user) { User.new roles: [:user_inviter] }
      let(:params) { { whatever: :doesnt_matter } }
      it "does not allow the user to change any user's permissions" do
        expect { subject }.to raise_error "Not authorized"
      end
    end

    context 'with a user who is a superadmin' do
      let(:current_user) { User.create! id: 8085860000, email: '0', roles: [:superadmin] }
      let!(:user_1) { User.create! id: 8085860001, email: '1' }
      let!(:user_2) { User.create! id: 8085860002, email: '2' }
      let!(:user_3) { User.create! id: 8085860003, email: '3', roles: [:data_editor] }
      let!(:user_4) { User.create! id: 8085860004, email: '4', roles: [:superadmin] }
      let(:params) do
        {
          '8085860001-superadmin' => '1',
          '8085860001-user_inviter' => '0',
          '8085860001-cms_editor' => '0',
          '8085860001-data_editor' => '0',
          '8085860001-data_contributor' => '0',

          '8085860002-superadmin' => '0',
          '8085860002-user_inviter' => '1',
          '8085860002-cms_editor' => '1',
          '8085860002-data_editor' => '1',
          '8085860002-data_contributor' => '0',

          '8085860003-superadmin' => '0',
          '8085860003-user_inviter' => '0',
          '8085860003-cms_editor' => '0',
          '8085860003-data_editor' => '0',
          '8085860003-data_contributor' => '1',

          '8085860004-superadmin' => '0',
          '8085860004-user_inviter' => '0',
          '8085860004-cms_editor' => '0',
          '8085860004-data_editor' => '0',
          '8085860004-data_contributor' => '0',
        }
      end

      it 'changes user permissions as expected' do
        expect { subject }
          .to not_change { current_user.reload.roles }
          .and change { user_1.reload.roles }.from([]).to(%i[superadmin])
          .and change { user_2.reload.roles }.from([]).to(%i[user_inviter cms_editor data_editor])
          .and change { user_3.reload.roles }.from(%i[data_editor]).to(%i[data_contributor])
          .and not_change { user_4.reload.roles }
      end

      context 'with invalid value' do
        let(:params) { { '8085860002-user_inviter' => 'true' } }
        it 'raises the expected error' do
          expect { subject }.to raise_error "Invalid value true"
        end
      end
    end
  end
end
