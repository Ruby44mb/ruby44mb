describe FastlaneCore do
  describe FastlaneCore::IpaFileAnalyser do
    let(:ipa) { 'iOSAppOnly' }
    let(:path) { File.expand_path("../fixtures/ipas/#{ipa}.ipa", __FILE__) }

    context 'with fetch_info_plist_with_rubyzip' do
      before(:each) do
        expect(FastlaneCore::IpaFileAnalyser).to receive(:fetch_info_plist_with_rubyzip).and_call_original
      end

      describe '::fetch_app_identifier' do
        subject { described_class.fetch_app_identifier(path) }
        it { is_expected.to eq('com.example.Sample') }
        context 'when contains embedded app bundle' do
          let('ipa') { 'ContainsWatchApp' }
          it { is_expected.to eq('com.example.Sample') }
        end
      end

      describe '::fetch_app_build' do
        subject { described_class.fetch_app_build(path) }
        it { is_expected.to eq('1') }
        context 'when contains embedded app bundle' do
          let('ipa') { 'ContainsWatchApp' }
          it { is_expected.to eq('1') }
        end
      end
    end

    context 'with fetch_info_plist_with_unzip' do
      unless FastlaneCore::Helper.windows?
        before(:each) do
          expect(FastlaneCore::IpaFileAnalyser).to receive(:fetch_info_plist_with_rubyzip).and_return(nil)
          expect(FastlaneCore::IpaFileAnalyser).to receive(:fetch_info_plist_with_unzip).and_call_original
        end

        describe '::fetch_app_identifier' do
          subject { described_class.fetch_app_identifier(path) }
          it { is_expected.to eq('com.example.Sample') }
          context 'when contains embedded app bundle' do
            let('ipa') { 'ContainsWatchApp' }
            it { is_expected.to eq('com.example.Sample') }
          end
        end

        describe '::fetch_app_build' do
          subject { described_class.fetch_app_build(path) }
          it { is_expected.to eq('1') }
          context 'when contains embedded app bundle' do
            let('ipa') { 'ContainsWatchApp' }
            it { is_expected.to eq('1') }
          end
        end
      end
    end
  end
end
