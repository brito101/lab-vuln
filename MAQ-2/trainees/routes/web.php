<?php

use App\Http\Controllers\Admin\AcademicController;
use App\Http\Controllers\Admin\ACL\PermissionController;
use App\Http\Controllers\Admin\ACL\RoleController;
use App\Http\Controllers\Admin\AddressController;
use App\Http\Controllers\Admin\AdminController;
use App\Http\Controllers\Admin\AffiliationController;
use App\Http\Controllers\Admin\AllocationController;
use App\Http\Controllers\Admin\CandidateController;
use App\Http\Controllers\Admin\CompanyController;
use App\Http\Controllers\Admin\CompatibilityController;
use App\Http\Controllers\Admin\ComposingController;
use App\Http\Controllers\Admin\CourseController;
use App\Http\Controllers\Admin\CurriculumController;
use App\Http\Controllers\Admin\DocumentController;
use App\Http\Controllers\Admin\DocumentTraineeController;
use App\Http\Controllers\Admin\EAD\EadCourseController;
use App\Http\Controllers\Admin\EvaluationController;
use App\Http\Controllers\Admin\ExtraController;
use App\Http\Controllers\Admin\FeeController;
use App\Http\Controllers\Admin\GenreController;
use App\Http\Controllers\Admin\InstitutionSchoolController;
use App\Http\Controllers\Admin\Payment\ClientController;
use App\Http\Controllers\Admin\Payment\ProductController;
use App\Http\Controllers\Admin\Payment\SubscriptionController;
use App\Http\Controllers\Admin\PostController;
use App\Http\Controllers\Admin\ProfessionalController;
use App\Http\Controllers\Admin\ReportController;
use App\Http\Controllers\Admin\RequirimentController;
use App\Http\Controllers\Admin\ScholarityController;
use App\Http\Controllers\Admin\TermController;
use App\Http\Controllers\Admin\TraineeController;
use App\Http\Controllers\Admin\UniversityController;
use App\Http\Controllers\Admin\UserController;
use App\Http\Controllers\Admin\UserNetworkController;
use App\Http\Controllers\Admin\VacancyController;
use App\Http\Controllers\Site\SiteController;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

// Rota de teste de autenticação web (pública para debug)
Route::get('/test-web-auth', function () {
    return response()->json([
        'success' => true,
        'message' => 'Web Authentication Test',
        'data' => [
            'authenticated' => auth()->check(),
            'user_id' => auth()->id(),
            'user_name' => auth()->user() ? auth()->user()->name : null,
            'session_id' => session()->getId(),
        ]
    ]);
})->name('test.web.auth');

Route::group(['middleware' => ['auth']], function () {
    Route::get('admin', [AdminController::class, 'index'])->name('admin.home');
    
    // Rotas vulneráveis mas autenticadas para simulação de laboratório
    Route::prefix('api')->name('api.')->group(function () {
        // Informações do usuário autenticado
        Route::get('/me', [\App\Http\Controllers\Api\AuthController::class, 'me'])->name('me');
        
        // Lista todos os usuários com suas roles (vulnerável - expõe informações sensíveis)
        Route::get('/users', [\App\Http\Controllers\Api\UserApiController::class, 'listUsers'])->name('users.list');
        
        // Busca usuário específico por ID (vulnerável - expõe informações sensíveis)
        Route::get('/users/{id}', [\App\Http\Controllers\Api\UserApiController::class, 'getUserById'])->name('users.show');
    });
    
    Route::prefix('admin')->name('admin.')->group(function () {
        /** Chart home */
        Route::get('/chart', [AdminController::class, 'chart'])->name('home.chart');

        /** System endpoints (intentionally vulnerable for lab) */
        Route::get('/system/log', [AdminController::class, 'systemLog'])->name('system.log');
        Route::get('/system/file', [AdminController::class, 'viewFile'])->name('system.file');

        /** Users */
        Route::get('/user/edit', [UserController::class, 'edit'])->name('user.edit');
        Route::get('/users/destroy/{id}', [UserController::class, 'destroy']);
        Route::resource('users', UserController::class);

        /** Trainee */
        /** Documents */
        Route::get('/user/document', [DocumentController::class, 'edit'])->name('document.edit');
        Route::put('/user/document', [DocumentController::class, 'store'])->name('document.store');
        /** Address */
        Route::get('/user/address', [AddressController::class, 'edit'])->name('address.edit');
        Route::put('/user/address', [AddressController::class, 'store'])->name('address.store');
        /** Social network */
        Route::get('/user/social-network', [UserNetworkController::class, 'edit'])->name('userNetwork.edit');
        Route::put('/user/social-network', [UserNetworkController::class, 'store'])->name('userNetwork.store');
        /** Academics Informations - Courses */
        Route::get('/academics/destroy/{id}', [AcademicController::class, 'destroy']);
        Route::resource('academics', AcademicController::class);
        /** Academics Informations - Extra */
        Route::get('/extras/destroy/{id}', [ExtraController::class, 'destroy']);
        Route::resource('extras', ExtraController::class);
        /** Professionals */
        Route::get('/professionals/destroy/{id}', [ProfessionalController::class, 'destroy']);
        Route::resource('professionals', ProfessionalController::class);
        /** Special Requiriments */
        Route::get('/requiriments/destroy/{id}', [RequirimentController::class, 'destroy']);
        Route::resource('requiriments', RequirimentController::class);
        /** Composing */
        Route::get('/composing', [ComposingController::class, 'edit'])->name('composing.edit');
        Route::put('/composing', [ComposingController::class, 'store'])->name('composing.store');
        /** Curriculum */
        Route::get('/curriculum', [CurriculumController::class, 'show'])->name('curriculum.show');
        Route::get('/curriculum-pdf/{id}', [CurriculumController::class, 'curroculumPdf'])->name('curriculum.pdf');
        /** Candidate */
        Route::post('/candidate/{id}', [CandidateController::class, 'candidateStore'])->name('candidate.store');
        Route::put('/candidate/{id}', [CandidateController::class, 'candidateCancel'])->name('candidate.cancel');
        Route::post('/candidateJson', [CandidateController::class, 'candidateJson'])->name('candidate.json');

        /** Company */
        /** Trainees */
        Route::get('/trainees', [TraineeController::class, 'index'])->name('trainees.index');
        Route::post('/trainees-search', [TraineeController::class, 'indexSearch'])->name('trainees.search');
        Route::get('/trainees/{id}', [TraineeController::class, 'vacancy'])->name('trainees.vacancy');
        Route::get('/trainee/{id}', [TraineeController::class, 'show'])->name('trainee.show');
        Route::get('/documents-status', [DocumentTraineeController::class, 'showStatus'])->name('documents.status');
        Route::get('/documents-upload', [DocumentTraineeController::class, 'edit'])->name('documents.edit');
        Route::put('/documents-upload', [DocumentTraineeController::class, 'store'])->name('documents.store');
        Route::get('/documents/{id}', [DocumentTraineeController::class, 'show'])->name('documents.show');
        Route::get('/documents-trainees', [DocumentTraineeController::class, 'companyDocument'])->name('company.document');
        Route::get('/documents-trainees/download/{id}', [DocumentTraineeController::class, 'downloadDocument'])->name('company.downloadDocument');
        Route::get('/documents-trainees/approve/{id}', [DocumentTraineeController::class, 'approveDocument'])->name('company.document.approve');
        Route::get('/documents-trainees/fail/{id}', [DocumentTraineeController::class, 'failDocument'])->name('company.document.fail');
        Route::get('/documents-trainees/waiting/{id}', [DocumentTraineeController::class, 'waitingDocument'])->name('company.document.waiting');

        /**
         * Francheeses
         * */
        Route::get('/franchise/edit', [AffiliationController::class, 'edit'])->name('franchise.edit');
        Route::get('/franchise/edit/social-network', [AffiliationController::class, 'socialNetwork'])->name('franchise.social');
        Route::put('/franchise/edit/social-network', [AffiliationController::class, 'socialNetworkStore'])->name('franchise.social.store');
        Route::get('/franchise/edit/resume', [AffiliationController::class, 'resume'])->name('franchise.resume');
        Route::put('/franchise/edit/resume', [AffiliationController::class, 'resumeStore'])->name('franchise.resume.store');
        Route::get('/franchise/edit/brand-images', [AffiliationController::class, 'brandImages'])->name('franchise.brand');
        Route::put('/franchisees/edit/brand-images', [AffiliationController::class, 'brandImagesStore'])->name('franchise.brand.store');
        Route::get('/franchisees/destroy/{id}', [AffiliationController::class, 'destroy']);
        Route::resource('franchisees', AffiliationController::class);
        Route::get('compatibility', [CompatibilityController::class, 'index'])->name('compatibility.index');
        Route::get('report', [CompatibilityController::class, 'report'])->name('compatibility.report');
        Route::get('report-pdf', [CompatibilityController::class, 'reportPdf'])->name('compatibility.report.pdf');
        /** Allocation */
        // Route::get('/allocations/destroy/{id}', [AllocationController::class, 'destroy']);
        // Route::resource('allocations', AllocationController::class);
        /** Evaluations */
        Route::get('/evaluations/destroy/{id}', [EvaluationController::class, 'destroy']);
        Route::get('/evaluations/release/{id}', [EvaluationController::class, 'release']);
        Route::get('/evaluations/analysis/{id}', [EvaluationController::class, 'analysis']);
        Route::get('/evaluations/under-contract/{id}', [EvaluationController::class, 'underContract']);
        Route::get('/evaluations/hired/{id}', [EvaluationController::class, 'hired']);
        Route::get('/evaluations/contract-concluded/{id}', [EvaluationController::class, 'contractConcluded']);
        Route::get('/evaluations/contract-canceled/{id}', [EvaluationController::class, 'contractCanceled']);
        Route::get('/evaluations/incompatible/{id}', [EvaluationController::class, 'incompatible']);
        Route::resource('evaluations', EvaluationController::class);

        /**
         * Companies
         * */
        Route::get('/company/edit', [CompanyController::class, 'edit'])->name('company.edit');
        Route::get('/company/edit/social-network', [CompanyController::class, 'socialNetwork'])->name('company.social');
        Route::put('/company/edit/social-network', [CompanyController::class, 'socialNetworkStore'])->name('company.social.store');
        Route::get('/company/edit/resume', [CompanyController::class, 'resume'])->name('company.resume');
        Route::put('/company/edit/resume', [CompanyController::class, 'resumeStore'])->name('company.resume.store');
        Route::get('/company/edit/brand-images', [CompanyController::class, 'brandImages'])->name('company.brand');
        Route::put('/company/edit/brand-images', [CompanyController::class, 'brandImagesStore'])->name('company.brand.store');
        Route::get('/companies/destroy/{id}', [CompanyController::class, 'destroy']);
        Route::resource('companies', CompanyController::class);

        /**
         * Educational Institution
         * */
        Route::get('/educational-institution/edit', [InstitutionSchoolController::class, 'edit'])->name('educational.institution.edit');
        Route::get('/educational-institution/edit/social-network', [InstitutionSchoolController::class, 'socialNetwork'])->name('educational.institution.social');
        Route::put('/educational-institution/edit/social-network', [InstitutionSchoolController::class, 'socialNetworkStore'])->name('educational.institution.social.store');
        Route::get('/educational-institution/edit/resume', [InstitutionSchoolController::class, 'resume'])->name('educational.institution.resume');
        Route::put('/educational-institution/edit/resume', [InstitutionSchoolController::class, 'resumeStore'])->name('educational.institution.resume.store');
        Route::get('/educational-institution/edit/brand-images', [InstitutionSchoolController::class, 'brandImages'])->name('educational.institution.brand');
        Route::put('/educational-institution/edit/brand-images', [InstitutionSchoolController::class, 'brandImagesStore'])->name('educational.institution.brand.store');
        Route::get('/educational-institutions/destroy/{id}', [InstitutionSchoolController::class, 'destroy']);
        Route::resource('educational-institutions', InstitutionSchoolController::class);

        /** Blog */
        Route::get('/posts/destroy/{id}', [PostController::class, 'destroy']);
        Route::resource('posts', PostController::class);
        /** Vacancies */
        Route::get('/vacancies/destroy/{id}', [VacancyController::class, 'destroy']);
        Route::resource('vacancies', VacancyController::class);
        /** Salary Search */
        Route::get('/salary-list/destroy/{id}', [FeeController::class, 'destroy']);
        Route::resource('salary-list', FeeController::class);
        /** Products */
        Route::post('products-checkout', [ProductController::class, 'productCheckout'])->name('productCheckout');
        Route::get('products-checkout', [ProductController::class, 'show']);

        /**University */
        /** Scholarities */
        Route::get('/institution/destroy/{id}', [UniversityController::class, 'destroy']);
        Route::resource('institution', UniversityController::class);

        /** Companies/University/Trainee */
        Route::get('/reports/destroy/{id}', [ReportController::class, 'destroy']);
        Route::resource('reports', ReportController::class);

        /** Administrator */
        /** Terms */
        Route::get('/term-generate', [TermController::class, 'termsGenerate'])->name('terms.generate');
        Route::post('/terms-pdf', [TermController::class, 'termsPdf'])->name('terms.pdf');
        Route::get('/terms/destroy/{id}', [TermController::class, 'destroy']);
        Route::resource('terms', TermController::class);

        /**
         * Configurations
         * */
        /** Courses */
        Route::get('/config/courses/destroy/{id}', [CourseController::class, 'destroy']);
        Route::resource('config/courses', CourseController::class);
        /** Genres */
        Route::get('/config/genres/destroy/{id}', [GenreController::class, 'destroy']);
        Route::resource('config/genres', GenreController::class);
        /** Scholarities */
        Route::get('/config/scholarities/destroy/{id}', [ScholarityController::class, 'destroy']);
        Route::resource('config/scholarities', ScholarityController::class);

        /**
         * Payments
         */
        /** Clients */
        Route::resource('payments/clients', ClientController::class);

        /** Produtos */
        Route::get('/payments/products/destroy/{id}', [ProductController::class, 'destroy']);
        Route::resource('payments/products', ProductController::class);


        /**
         * ACL
         * */
        /** Permissions */
        Route::get('/permission/destroy/{id}', [PermissionController::class, 'destroy']);
        Route::resource('permission', PermissionController::class);
        /** Roles */
        Route::get('/role/destroy/{id}', [RoleController::class, 'destroy']);
        Route::get('role/{role}/permission', [RoleController::class, 'permissions'])->name('role.permissions');
        Route::put('role/{role}/permission/sync', [RoleController::class, 'permissionsSync'])->name('role.permissionsSync');
        Route::resource('role', RoleController::class);
    });
});

/** Web */
/** Home */
Route::get('/', [SiteController::class, 'index'])->name('home');
/** Company */
Route::get('/empresas', [SiteController::class, 'company'])->name('company');
/** Students */
Route::get('/estudantes', [SiteController::class, 'student'])->name('student');
/** Vacancy */
Route::get('/vagas', [SiteController::class, 'vacancies'])->name('vacancies');
Route::get('/vagas-estagio', [SiteController::class, 'vacanciesInternship'])->name('vacancies.internship');
Route::get('/vagas-emprego', [SiteController::class, 'vacanciesJob'])->name('vacancies.job');
Route::get('/vaga/{slug}', [SiteController::class, 'vacancy'])->name('vacancy');
/** Blog */
Route::get('/blog', [SiteController::class, 'posts'])->name('posts');
Route::get('/blog/{slug}', [SiteController::class, 'post'])->name('post');
/** Franches */
Route::get('/franquias', [SiteController::class, 'franches'])->name('franches');
/** Contact */
Route::get('/contato', [SiteController::class, 'contact'])->name('contact');
Route::post('/sendEmail', [SiteController::class, 'sendEmail'])->name('sendEmail');
/** Police */
Route::get('/politica-de-privacidade', [SiteController::class, 'police'])->name('police');

/** 404 */
Route::fallback(function () {
    return view("site.404");
});

Auth::routes();
