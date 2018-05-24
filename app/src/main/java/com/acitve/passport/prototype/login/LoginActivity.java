public class loginActivity extends AppCompatActivity implements loginContract.View {
    private loginContract.Presenter presenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.p_login_activity);

        presenter = new loginPresenter();
        presenter.setView(this);
    }
}
