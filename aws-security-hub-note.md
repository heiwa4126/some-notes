# AWSAWS Security Hub (主に AWS Security Hub CSPM) のメモ

CSMP=Cloud Security Posture Management

クラウド環境のセキュリティ状態を継続チェック + 可視化 + 修正支援する仕組み

## CSPM のFindings で Severity が HIGH以上 のフィルターはどう設定すればいいですか?

Amazon Q の答え

**重要な注意点**

Severity (normalized) は非推奨となっており、現在は Severity Label の使用が推奨されています。
Severity Labelを使用する場合は、HIGH とCRITICAL の両方を指定する必要があります。
複数の フィルターはOR条件で結合されるため、
`Severity label is HIGH` と `Severity label is CRITICAL` 両方設定すれば、HIGH以上の結果が得られます。

- 同じ属性の複数値は OR
- 異なる属性間は AND

なにそれ...

## ルール

AWS Security Hub CSPM は口うるさいけど便利なものですね。
これベストプラクティスなルールはデフォルトで設定されていますか?

(以下Sonnetの答えそのまま)

はい、デフォルトで有効になります。Security Hub CSPM をコンソール・API・CLIのいずれで有効化しても、明示的にオフにしない限り次の2つの標準が自動的に有効になります。

- **AWS Foundational Security Best Practices (FSBP) v1.0.0**
- **CIS AWS Foundations Benchmark v1.2.0**

EnableSecurityHub APIを呼び出してSecurity Hub CSPMを有効にすると、AWS基本的なセキュリティのベストプラクティスとCenter for Internet Security (CIS) AWS Foundations Benchmark v1.2.0という2つのデフォルトのセキュリティ標準が自動的に有効になります。CLIの場合は `aws securityhub enable-security-hub --enable-default-standards`(デフォルトでこの動作)、無効にしたい場合は `--no-enable-default-standards` を指定します。

**組織でのauto-enable(自動有効化)の場合も同様**で、ローカル設定で自動有効化をオンにすると新規組織アカウントのデフォルト標準はFSBPとCIS v1.2.0になり、このデフォルト標準は変更できません。他の標準(PCI DSS、NIST 800-53など)を組織全体やOU単位で適用したい場合は、Central Configuration(中央設定)の設定ポリシーを使う必要があります。

**FSBP標準そのものについて**:

- AWSと業界の専門家によって開発されたFSBP標準は、アカウントとリソースがセキュリティのベストプラクティスから逸脱した場合を検出する一連のコントロールを提供します。S3、IAM、EC2、RDS、ELBなど多数のAWSサービスにわたるコントロール(数百個)が含まれ、標準を有効にすると配下のコントロールは基本的に全部有効になります。
- Control Towerを使っている場合、Control Towerはデフォルトのアカウント設定がSecurity Hub CSPMのFSBPに沿っているかを確認するのにも役立ちます。

**運用上の注意点(口うるさい所以)**:

- 標準を有効にする前に AWS Config のリソース記録を正しく設定しておく必要があり、記録が無効な期間があるとそのコントロールはリソースの実際の状態を評価しないWARNING検出結果になる点が地味にハマりポイントです。
- 個別コントロールの無効化やパラメータ変更は、中央設定の `DisabledSecurityControlIdentifiers` や `SecurityControlCustomParameters` で一括管理できます(例: ACMの`daysToExpiration`変更など)。

複数アカウント運用なら、最初から中央設定(Delegated administrator + Configuration Policy)で「AWS推奨ポリシー」を使うのが楽です。これはすべての組織アカウントでSecurity Hub CSPMを有効にし、FSBP標準を有効にし、すべての新規・既存FSBPコントロールを有効にするものなので、将素のコントロール追加にも追従してくれます。

(Opusの答え)

はい、Security Hub CSPM を有効化すると、**ベストプラクティス系の代表的な標準が最初からデフォルトで有効化**されます。とはいえ「全部入り」ではないので、少しだけ補足が必要です。

### デフォルトで有効化される標準

Security Hub CSPM を有効化した直後、以下の 2 つの標準が自動的に ON になります(`aws securityhub get-enabled-standards` で確認可能): [\[qiita.com\]](https://qiita.com/h_horiguchi/items/9e3d6ed3d73d5ea2953b)

| 標準                                                | バージョン | 位置づけ                                                                                                                                                                                        |
| --------------------------------------------------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **AWS Foundational Security Best Practices (FSBP)** | v1.0.0     | AWS とセキュリティ業界が共同策定。AWS が「まずこれ」と推奨する横断的ベストプラクティス集 [\[docs.aws.amazon.com\]](https://docs.aws.amazon.com/securityhub/latest/userguide/fsbp-standard.html) |
| **CIS AWS Foundations Benchmark**                   | v1.2.0     | Center for Internet Security による業界標準ベンチマーク [\[qiita.com\]](https://qiita.com/h_horiguchi/items/9e3d6ed3d73d5ea2953b)                                                               |

特に **FSBP** は、Account / ACM / API Gateway / EC2 / RDS / S3 など多数のサービスを横断するコントロールが含まれており、AWS が公式に「これがベースライン」と位置付けている標準です。「口うるさい」と感じる検出の多くは、ほぼこの FSBP 由来と思っていいです。 [\[docs.aws.amazon.com\]](https://docs.aws.amazon.com/securityhub/latest/userguide/fsbp-standard.html)

### デフォルトでは有効化されない標準

以下は CSPM では使えますが、**明示的に有効化が必要**です: [\[docs.aws.amazon.com\]](https://docs.aws.amazon.com/securityhub/latest/userguide/standards-reference.html)

- CIS AWS Foundations Benchmark **v1.4.0 / v3.0.0**(v1.2.0 は有効でも、新しい版は別途)
- **NIST SP 800-53 Revision 5**
- **NIST SP 800-171 Revision 2**
- **PCI DSS**
- **AWS Resource Tagging Standard**

### 知っておくと良いポイント

- 有効化直後の Hub 設定は `AutoEnableControls: true` になっており、**標準に新コントロールが追加されると自動的に有効化**されます。最近も 2025/10/28 に FSBP へ 6 個 (Cognito.3, DMS.13, EC2.181, RDS.43, RDS.47, RDS.48) が追加されています。 [\[qiita.com\]](https://qiita.com/h_horiguchi/items/9e3d6ed3d73d5ea2953b) [\[dev.classmethod.jp\]](https://dev.classmethod.jp/articles/securityhub-fsbp-6-new-controls-2025-10-28/)
- 何もリソースを作っていなくても、FSBP を有効化しただけで**20 個前後の非準拠 Findings** が出ます(GuardDuty 未有効化、EBS デフォルト暗号化未設定、デフォルト VPC 存在、など)。最初にこれらを潰しておくと、その後のリソース追加時の新規 Findings に気づきやすくなります。 [\[tech.dentsusoken.com\]](https://tech.dentsusoken.com/entry/initial_resource_setup_in_new_aws_region_for_security_hub_cspm)
- Findings を Severity HIGH 以上で絞る運用とセットで考えるなら、**FSBP をベースラインに固定 → 必要に応じて CIS v3.0.0 や NIST を追加**、という積み増し方が一般的です。

---

もし「うちは PCI DSS や NIST もチェックしたい」「逆に FSBP の特定コントロールがノイズなので無効化したい」みたいな話があれば、コントロール単位での有効/無効や Automation Rules による抑制方法もまとめられます。どうしましょう?
