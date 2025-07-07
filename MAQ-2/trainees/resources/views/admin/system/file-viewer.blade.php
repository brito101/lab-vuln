@extends('adminlte::page')

@section('title', 'System File Viewer')

@section('content')
<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title">System File Viewer</h4>
                    <p class="text-muted">View system files (Administrator access required)</p>
                </div>
                <div class="card-body">
                    <form method="GET" action="{{ route('admin.system.file') }}">
                        <div class="form-group">
                            <label for="file">File Path:</label>
                            <input type="text" class="form-control" id="file" name="file" 
                                   value="{{ $file ?? '' }}" 
                                   placeholder="e.g., /etc/passwd, /var/log/apache2/access.log">
                            <small class="form-text text-muted">
                                Enter the full path to the file you want to view
                            </small>
                        </div>
                        <button type="submit" class="btn btn-primary">View File</button>
                    </form>

                    @if(isset($content) && $content !== '')
                        <hr>
                        <div class="mt-4">
                            <h5>File Content: {{ $file }}</h5>
                            <div class="bg-light p-3 rounded">
                                <pre style="max-height: 500px; overflow-y: auto;">{{ $content }}</pre>
                            </div>
                        </div>
                    @endif

                    <hr>
                    <div class="mt-4">
                        <h5>Common Files to Try:</h5>
                        <ul class="list-group">
                            <li class="list-group-item">
                                <strong>/etc/passwd</strong> - User account information
                            </li>
                            <li class="list-group-item">
                                <strong>/etc/shadow</strong> - Encrypted password information
                            </li>
                            <li class="list-group-item">
                                <strong>/etc/passwd</strong> - User account information
                            </li>
                            <li class="list-group-item">
                                <strong>/proc/version</strong> - Kernel version information
                            </li>
                            <li class="list-group-item">
                                <strong>/etc/hosts</strong> - Hostname resolution
                            </li>
                            <li class="list-group-item">
                                <strong>/var/www/html/storage/logs/laravel.log</strong> - Laravel application logs
                            </li>
                            <li class="list-group-item">
                                <strong>/proc/cpuinfo</strong> - CPU information
                            </li>
                            <li class="list-group-item">
                                <strong>/proc/meminfo</strong> - Memory information
                            </li>
                            <li class="list-group-item">
                                <strong>/proc/version</strong> - Kernel version information
                            </li>
                            <li class="list-group-item">
                                <strong>/etc/hosts</strong> - Hostname resolution
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection 